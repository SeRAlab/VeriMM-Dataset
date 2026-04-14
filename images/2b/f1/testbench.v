`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg end_signal;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data(data),
        .end_signal(end_signal),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single word (0x0001)", test_num);
            reset_dut();
            data = 16'h0001;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple words (no carry)", test_num);
            reset_dut();
            data = 16'h1234;
            end_signal = 1'b0;
            @(posedge clk);
            data = 16'h5678;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h9753);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Carry wrap-around", test_num);
            reset_dut();
            data = 16'hF000;
            end_signal = 1'b0;
            @(posedge clk);
            data = 16'h1000;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Ones (0xFFFF)", test_num);
            reset_dut();
            data = 16'hFFFF;
            end_signal = 1'b0;
            @(posedge clk);
            data = 16'hFFFF;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            reset_dut();
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple words with multiple carries", test_num);
            reset_dut();
            data = 16'hF000;
            @(posedge clk);
            data = 16'hF000;
            @(posedge clk);
            data = 16'hF000;
            end_signal = 1'b1;
            @(posedge clk);
            data = 16'h0000;
            end_signal = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h2FFD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
