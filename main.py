import glfw
from OpenGL.GL import *
import numpy as np


def compileShader(shaderType, src):
    id = glCreateShader(shaderType)
    glShaderSource(id, src)
    glCompileShader(id)
    # Проверяем статус компиляции шейдера
    success = glGetShaderiv(id, GL_COMPILE_STATUS)
    if not success:
        infoLog = glGetShaderInfoLog(id)
        print("Shader compilation error:", infoLog.decode("utf-8"))

    return id


def createShader(vertex, fragment):
    vs = compileShader(GL_VERTEX_SHADER, vertex)
    fs = compileShader(GL_FRAGMENT_SHADER, fragment)

    program = glCreateProgram()
    glAttachShader(program, vs)
    glAttachShader(program, fs)
    glLinkProgram(program)

    # Проверяем статус связывания программы шейдеров
    success = glGetProgramiv(program, GL_LINK_STATUS)
    if not success:
        infoLog = glGetProgramInfoLog(program)
        print("Shader program linking error:", infoLog.decode("utf-8"))

    glValidateProgram(program)

    glDeleteShader(vs)
    glDeleteShader(fs)

    return program


def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(1280, 720, "Hello World", None, None)
    if not window:
        glfw.terminate()
        return

    # Make the window's context current
    glfw.make_context_current(window)

    vertices = [
        -1.0, -1.0,
        1.0, -1.0,
        1.0, 1.0,
        1.0, 1.0,
        -1.0, 1.0,
        -1.0, -1.0,
    ]

    # Преобразование списка вершин в массив NumPy
    converted = np.array(vertices, dtype=np.float32)

    VBO = glGenBuffers(1)
    glBindBuffer(GL_ARRAY_BUFFER, VBO)
    glBufferData(GL_ARRAY_BUFFER, converted, GL_STATIC_DRAW)

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * 4, None)
    glEnableVertexAttribArray(0)

    with open("vertex.shader") as f:
        vertex_shader = f.read()
    with open("fragment.shader") as f:
        fragment_shader = f.read()

    shader = createShader(vertex_shader, fragment_shader)
    glUseProgram(shader)

    glUniform2f(glGetUniformLocation(shader, "iResolution"), 1280, 720)

    # Loop until the user closes the window
    while not glfw.window_should_close(window):
        glUniform1f(glGetUniformLocation(shader, "iTime"), glfw.get_time())
        # Render here, e.g. using pyOpenGL
        glClear(GL_COLOR_BUFFER_BIT)
        glDrawArrays(GL_TRIANGLES, 0, 6)

        # Swap front and back buffers
        glfw.swap_buffers(window)

        # Poll for and process events
        glfw.poll_events()

    glfw.terminate()


if __name__ == "__main__":
    main()
