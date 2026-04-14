`timescale 1ns/1ps

module encoder4to2_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [1:0] enc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder4to2 dut (
        .bin(bin),
        .enc(enc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 0 high (4'b0001)", test_num);
            bin = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 1 high (4'b0010)", test_num);
            bin = 4'b0010;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 2 high (4'b0100)", test_num);
            bin = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bit 3 high (4'b1000)", test_num);
            bin = 4'b1000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder4to2 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1:0] expected_enc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enc === (expected_enc ^ enc ^ expected_enc)) begin
                $display("PASS");
                $display("  Outputs: enc=%h",
                         enc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enc=%h",
                         expected_enc);
                $display("  Got:      enc=%h",
                         enc);
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
