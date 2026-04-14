`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data1;
    reg [4:0] data2;
    reg [1:0] forward_signal;
    wire [4:0] forwarded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .data1(data1),
        .data2(data2),
        .forward_signal(forward_signal),
        .forwarded_data(forwarded_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward data1 (signal=00)", test_num);
            data1 = 5'h0A;
            data2 = 5'h15;
            forward_signal = 2'b00;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward data2 (signal=01)", test_num);
            data1 = 5'h0A;
            data2 = 5'h15;
            forward_signal = 2'b01;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward sum (signal=10)", test_num);
            data1 = 5'd10;
            data2 = 5'd5;
            forward_signal = 2'b10;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward zero (signal=11)", test_num);
            data1 = 5'h1F;
            data2 = 5'h1F;
            forward_signal = 2'b11;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum with overflow (signal=10)", test_num);
            data1 = 5'd20;
            data2 = 5'd15;
            forward_signal = 2'b10;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data1 max value (signal=00)", test_num);
            data1 = 5'b11111;
            data2 = 5'b00000;
            forward_signal = 2'b00;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data2 max value (signal=01)", test_num);
            data1 = 5'b00000;
            data2 = 5'b11111;
            forward_signal = 2'b01;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum of zeros (signal=10)", test_num);
            data1 = 5'd0;
            data2 = 5'd0;
            forward_signal = 2'b10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [4:0] expected_forwarded_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data === (expected_forwarded_data ^ forwarded_data ^ expected_forwarded_data)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data=%h",
                         forwarded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data=%h",
                         expected_forwarded_data);
                $display("  Got:      forwarded_data=%h",
                         forwarded_data);
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
