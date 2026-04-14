`timescale 1ns/1ps

module sd_card_interface_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cmd;
    reg valid;
    wire [7:0] resp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_interface dut (
        .cmd(cmd),
        .valid(valid),
        .resp(resp)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Command 8'h01, Valid High", test_num);
            cmd = 8'h01;
            valid = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Command 8'h02, Valid High", test_num);
            cmd = 8'h02;
            valid = 1'b1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Command 8'h03, Valid High", test_num);
            cmd = 8'h03;
            valid = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Command 8'h04 (Undefined), Valid High", test_num);
            cmd = 8'h04;
            valid = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Command 8'hFF (Undefined), Valid High", test_num);
            cmd = 8'hFF;
            valid = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Command 8'h01, Valid Low", test_num);
            cmd = 8'h01;
            valid = 1'b0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Command 8'h02, Valid Low", test_num);
            cmd = 8'h02;
            valid = 1'b0;
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
        $display("sd_card_interface Testbench");
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
        input [7:0] expected_resp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resp === (expected_resp ^ resp ^ expected_resp)) begin
                $display("PASS");
                $display("  Outputs: resp=%h",
                         resp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resp=%h",
                         expected_resp);
                $display("  Got:      resp=%h",
                         resp);
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
