`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg serial_in;
    wire [7:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            serial_in = 0;
            repeat(2) @(negedge clk);
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in all 1s", test_num);
            reset_dut();
            repeat(8) begin
                @(negedge clk);
                serial_in = 1;
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in alternating 10101010", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                serial_in = (i % 2 == 0) ? 1 : 0;
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in alternating 01010101", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                serial_in = (i % 2 == 0) ? 0 : 1;
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift single 1 to MSB", test_num);
            reset_dut();

            @(negedge clk);
            serial_in = 1;

            repeat(7) begin
                @(negedge clk);
                serial_in = 0;
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow check (12 bits)", test_num);
            reset_dut();




            repeat(4) begin @(negedge clk); serial_in = 1; end

            @(negedge clk); serial_in = 1;
            @(negedge clk); serial_in = 0;
            @(negedge clk); serial_in = 1;
            @(negedge clk); serial_in = 0;

            @(negedge clk); serial_in = 0;
            @(negedge clk); serial_in = 1;
            @(negedge clk); serial_in = 0;
            @(negedge clk); serial_in = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Async Reset during operation", test_num);
            reset_dut();

            repeat(4) begin @(negedge clk); serial_in = 1; end

            #2;
            rst_n = 0;
            #10;
            rst_n = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, rst_n, serial_in, shift_reg);
    end

endmodule
