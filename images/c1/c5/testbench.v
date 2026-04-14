`timescale 1ns/1ps

module spio_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] i_btn;
    reg i_clk;
    reg [3:0] i_kp_row;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire o_btn_int;
    wire [3:0] o_kp_col;
    wire o_kp_int;
    wire [3:0] o_led;
    wire [31:0] o_wb_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spio dut (
        .i_btn(i_btn),
        .i_clk(i_clk),
        .i_kp_row(i_kp_row),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_btn_int(o_btn_int),
        .o_kp_col(o_kp_col),
        .o_kp_int(o_kp_int),
        .o_led(o_led),
        .o_wb_data(o_wb_data)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_btn = 2'b00;
            i_kp_row = 4'b0000;
            i_wb_cyc = 0;
            i_wb_stb = 0;
            i_wb_we = 0;
            i_wb_data = 32'h0;
            repeat(5) @(posedge i_clk);
        end
        endtask
    task wb_write;

        input [31:0] data;
        begin
            @(posedge i_clk);
            i_wb_cyc <= 1;
            i_wb_stb <= 1;
            i_wb_we  <= 1;
            i_wb_data <= data;
            @(posedge i_clk);
            i_wb_cyc <= 0;
            i_wb_stb <= 0;
            i_wb_we  <= 0;
            i_wb_data <= 0;
        end
        endtask

    task wb_read;

        begin
            @(posedge i_clk);
            i_wb_cyc <= 1;
            i_wb_stb <= 1;
            i_wb_we  <= 0;
            @(posedge i_clk);
            #1;
            i_wb_cyc <= 0;
            i_wb_stb <= 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: LED Write Operation", test_num);
            reset_dut();


            wb_write(32'h0000_000A);

            repeat(2) @(posedge i_clk);

            #1;


            check_outputs(1'b0, 4'h0, 1'b0, 4'hA, 32'h0000_000A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Keypad Column Write Operation", test_num);
            reset_dut();


            wb_write(32'h0000_0050);

            repeat(2) @(posedge i_clk);

            #1;


            check_outputs(1'b0, 4'h5, 1'b0, 4'h0, 32'h0000_0050);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Keypad Row Readback", test_num);
            reset_dut();


            i_kp_row = 4'hC;
            repeat(5) @(posedge i_clk);

            wb_read();



            #1;




            check_outputs(1'b0, 4'h0, 1'b1, 4'h0, 32'h0000_0C00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Button Input and Interrupt", test_num);
            reset_dut();


            i_btn = 2'b10;


            repeat(20) @(posedge i_clk);



            #1;




            check_outputs(1'b1, 4'h0, 1'b0, 4'h0, 32'h0000_2000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Combined Peripheral State", test_num);
            reset_dut();

            i_kp_row = 4'h3;
            i_btn = 2'b01;
            wb_write(32'h0000_00F5);

            repeat(20) @(posedge i_clk);
            wb_read();







            #1;








            check_outputs(1'b1, 4'hF, 1'b1, 4'h5, 32'h0000_13F5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spio Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_o_btn_int;
        input [3:0] expected_o_kp_col;
        input expected_o_kp_int;
        input [3:0] expected_o_led;
        input [31:0] expected_o_wb_data;
        begin
            if (expected_o_btn_int === (expected_o_btn_int ^ o_btn_int ^ expected_o_btn_int) &&
                expected_o_kp_col === (expected_o_kp_col ^ o_kp_col ^ expected_o_kp_col) &&
                expected_o_kp_int === (expected_o_kp_int ^ o_kp_int ^ expected_o_kp_int) &&
                expected_o_led === (expected_o_led ^ o_led ^ expected_o_led) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data)) begin
                $display("PASS");
                $display("  Outputs: o_btn_int=%b, o_kp_col=%h, o_kp_int=%b, o_led=%h, o_wb_data=%h",
                         o_btn_int, o_kp_col, o_kp_int, o_led, o_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_btn_int=%b, o_kp_col=%h, o_kp_int=%b, o_led=%h, o_wb_data=%h",
                         expected_o_btn_int, expected_o_kp_col, expected_o_kp_int, expected_o_led, expected_o_wb_data);
                $display("  Got:      o_btn_int=%b, o_kp_col=%h, o_kp_int=%b, o_led=%h, o_wb_data=%h",
                         o_btn_int, o_kp_col, o_kp_int, o_led, o_wb_data);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_btn, i_clk, i_kp_row, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_btn_int, o_kp_col, o_kp_int, o_led, o_wb_data);
    end

endmodule
