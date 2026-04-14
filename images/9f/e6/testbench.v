`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg last_in;
    reg ready_out;
    reg reset_in;
    reg [7:0] set_addr_in;
    reg set_stb_in;
    reg valid_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .last_in(last_in),
        .ready_out(ready_out),
        .reset_in(reset_in),
        .set_addr_in(set_addr_in),
        .set_stb_in(set_stb_in),
        .valid_in(valid_in)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset and Idle State", test_num);


            reset_in = 1'b1;
            data_in = 32'h0;
            last_in = 1'b0;
            ready_out = 1'b0;
            set_addr_in = 8'h0;
            set_stb_in = 1'b0;
            valid_in = 1'b0;

            #20;
            reset_in = 1'b0;
            #10;

            #1;


            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Input Transfer", test_num);


            reset_in = 1'b1;
            #20 reset_in = 1'b0;
            #10;


            data_in = 32'h12345678;
            valid_in = 1'b1;
            ready_out = 1'b1;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Configuration Strobe and Address", test_num);


            reset_in = 1'b1;
            #20 reset_in = 1'b0;
            #10;


            set_addr_in = 8'hA5;
            set_stb_in = 1'b1;

            #10;
            set_stb_in = 1'b0;
            #10;

            #1;


            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Last Data Item (End of Frame)", test_num);


            reset_in = 1'b1;
            #20 reset_in = 1'b0;
            #10;


            data_in = 32'hDEADBEEF;
            valid_in = 1'b1;
            last_in = 1'b1;
            ready_out = 1'b1;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Handshake Backpressure (Ready Low)", test_num);


            reset_in = 1'b1;
            #20 reset_in = 1'b0;
            #10;


            data_in = 32'hCAFEBABE;
            valid_in = 1'b1;
            ready_out = 1'b0;

            #20;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
