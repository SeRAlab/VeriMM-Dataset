`timescale 1ns/1ps

module prio_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] req_in;
    wire [2:0] code_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    prio_encoder dut (
        .req_in(req_in),
        .code_out(code_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 0 only", test_num);
            req_in = 8'b00000001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 7 only", test_num);
            req_in = 8'b10000000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check - bit 7 and others active", test_num);
            req_in = 8'b10101010;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check - bit 3 highest active", test_num);
            req_in = 8'b00001111;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 4 only", test_num);
            req_in = 8'b00010000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check - bit 5 and bit 4 active", test_num);
            req_in = 8'b00110000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All input bits active", test_num);
            req_in = 8'b11111111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 1 only", test_num);
            req_in = 8'b00000010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 6 only", test_num);
            req_in = 8'b01000000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No bits active (default output check)", test_num);
            req_in = 8'b00000000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("prio_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_code_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h",
                         code_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h",
                         expected_code_out);
                $display("  Got:      code_out=%h",
                         code_out);
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
