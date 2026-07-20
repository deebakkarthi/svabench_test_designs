// I2C registers wishbone addresses

// bitcontroller states
`define I2C_CMD_NOP   4'b0000
`define I2C_CMD_START 4'b0001
`define I2C_CMD_STOP  4'b0010
`define I2C_CMD_WRITE 4'b0100
`define I2C_CMD_READ  4'b1000

`define I2C_SLAVE_CMD_WRITE 2'b01
`define I2C_SLAVE_CMD_READ 2'b10
`define I2C_SLAVE_CMD_NOP 2'b00
