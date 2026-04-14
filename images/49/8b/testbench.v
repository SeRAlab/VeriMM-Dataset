`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [3:0] control;
    reg [15:0] data;
    wire [15:0] data_out;
    wire flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .control(control),
        .data(data),
        .data_out(data_out),
        .flag(flag)
    );

    // Clock generation (10ns period)
    initial begin
        control = 0;
        forever #5 control = ~control;
    end

        task reset_dut;

        begin
            addr = 8'h0;
            data = 16'h0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bulk Write Pattern 0xAAAA and Verify Match", test_num);
            reset_dut();


            addr = 8'h10;
            data = 16'hAAAA;
            #10;



            #10;
            #1;

            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Mismatch Flag (Success/Failure indicator)", test_num);
            reset_dut();


            addr = 8'h20;
            data = 16'h5555;
            #10;



            data = 16'h1234;
            #10;
            #1;

            check_outputs(16'h5555, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 0xFF Match", test_num);
            reset_dut();


            addr = 8'hFF;
            data = 16'hCCCC;
            #10;


            #10;
            #1;

            check_outputs(16'hCCCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Memory and Verify Update", test_num);
            reset_dut();


            data = 16'h1111;
            #10;


            data = 16'h2222;
            #10;


            addr = 8'h50;
            #10;
            #1;

            check_outputs(16'h2222, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 0x00 with Zero Pattern", test_num);
            reset_dut();


            addr = 8'h00;
            data = 16'h0000;
            #10;


            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_flag;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_flag === (expected_flag ^ flag ^ expected_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, flag=%b",
                         data_out, flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, flag=%b",
                         expected_data_out, expected_flag);
                $display("  Got:      data_out=%h, flag=%b",
                         data_out, flag);
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
        $dumpvars(0,addr, control, data, data_out, flag);
    end

endmodule
