`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [4:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .data_in(data_in),
        .position(position)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB bit set (data_in = 32'h00000001)", test_num);
            data_in = 32'h00000001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB bit set (data_in = 32'h80000000)", test_num);
            data_in = 32'h80000000;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle bit set (data_in = 32'h00008000)", test_num);
            data_in = 32'h00008000;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple low bits set (data_in = 32'h0000000F)", test_num);
            data_in = 32'h0000000F;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple high bits set (data_in = 32'hF0000000)", test_num);
            data_in = 32'hF0000000;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits set (data_in = 32'hFFFFFFFF)", test_num);
            data_in = 32'hFFFFFFFF;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (data_in = 32'h55555555)", test_num);
            data_in = 32'h55555555;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (data_in = 32'h00400000)", test_num);
            data_in = 32'h00400000;
            #1;

            check_outputs(5'd22);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sparse bits (data_in = 32'h00001001)", test_num);
            data_in = 32'h00001001;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Highest bit in lower word (data_in = 32'h0000FFFF)", test_num);
            data_in = 32'h0000FFFF;
            #1;

            check_outputs(5'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input [4:0] expected_position;
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
