`timescale 1ns/1ps

module priority_encoder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [2:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8bit dut (
        .data_in(data_in),
        .position(position)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            data_in = 8'b0000_0000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB only (Bit 0)", test_num);
            data_in = 8'b0000_0001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 1 high", test_num);
            data_in = 8'b0000_0010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB only (Bit 7)", test_num);
            data_in = 8'b1000_0000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple bits (7 and 0), 7 should win", test_num);
            data_in = 8'b1000_0001;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple bits (3, 2, 1), 3 should win", test_num);
            data_in = 8'b0000_1110;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 5 high", test_num);
            data_in = 8'b0010_0000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high, 7 should win", test_num);
            data_in = 8'b1111_1111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking one (Bit 4)", test_num);
            data_in = 8'h10;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 6 and lower bits", test_num);
            data_in = 8'b0111_1010;
            #1;

            check_outputs(3'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8bit Testbench");
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
        input [2:0] expected_position;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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
