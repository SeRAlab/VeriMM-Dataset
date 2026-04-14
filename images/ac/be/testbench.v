`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset_b;
    wire out_valid;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset_b(reset_b),
        .out_valid(out_valid),
        .serial_out(serial_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);

            reset_b = 0;
            load = 0;
            data_in = 8'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);

            reset_b = 1;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check MSB (Bit 7)", test_num);


            reset_b = 0; @(posedge clk); #1;
            reset_b = 1; @(posedge clk); #1;


            data_in = 8'b10000000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Middle Bit (Bit 4)", test_num);


            reset_b = 0; @(posedge clk); #1;
            reset_b = 1; @(posedge clk); #1;


            data_in = 8'b00010000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check LSB (Bit 0)", test_num);


            reset_b = 0; @(posedge clk); #1;
            reset_b = 1; @(posedge clk); #1;


            data_in = 8'b00000001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            repeat(7) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Valid Termination", test_num);


            reset_b = 0; @(posedge clk); #1;
            reset_b = 1; @(posedge clk); #1;


            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            repeat(8) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern Check (0xAA)", test_num);


            reset_b = 0; @(posedge clk); #1;
            reset_b = 1; @(posedge clk); #1;


            data_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_out_valid;
        input expected_serial_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: out_valid=%b, serial_out=%b",
                         out_valid, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_valid=%b, serial_out=%b",
                         expected_out_valid, expected_serial_out);
                $display("  Got:      out_valid=%b, serial_out=%b",
                         out_valid, serial_out);
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

endmodule
