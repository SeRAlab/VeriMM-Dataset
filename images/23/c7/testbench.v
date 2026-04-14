`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg re;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xA)", test_num);

            we = 0; re = 0; data_in = 4'b0000; #10;


            we = 1; data_in = 4'hA; #10;


            we = 0; re = 1; #10;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0x5)", test_num);

            we = 0; re = 0; data_in = 4'b0000; #10;


            we = 1; data_in = 4'h5; #10;


            we = 0; re = 1; #10;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable (WE) Gating", test_num);

            we = 1; data_in = 4'h3; #10;


            we = 0; data_in = 4'hF; #10;


            re = 1; #10;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (All 1s)", test_num);

            we = 0; re = 0; data_in = 4'b0000; #10;


            we = 1; data_in = 4'hF; #10;


            we = 0; re = 1; #10;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence/Stability", test_num);

            we = 0; re = 0; data_in = 4'b0000; #10;


            we = 1; data_in = 4'hC; #10;


            we = 0; re = 0; data_in = 4'h0; #20;


            re = 1; #10;

            #1;


            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
