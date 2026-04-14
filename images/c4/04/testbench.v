`timescale 1ns/1ps

module multiplier_block_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data0;
    wire [31:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_block dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input 0");
            i_data0 = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 1");
            i_data0 = 32'd1;
            #1;

            check_outputs(32'd16054);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 10");
            i_data0 = 32'd10;
            #1;

            check_outputs(32'd160540);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 1000");
            i_data0 = 32'd1000;
            #1;

            check_outputs(32'd16054000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input -1 (Signed)");
            i_data0 = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFC152);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Large input (Overflow)");
            i_data0 = 32'd300000;


            #1;



            check_outputs(32'h1F118540);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Power of 2 input");
            i_data0 = 32'h00010000;

            #1;


            check_outputs(32'h3EAE0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Hex value input 0x1234");
            i_data0 = 32'h1234;

            #1;


            check_outputs(32'h04758238);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_block Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
