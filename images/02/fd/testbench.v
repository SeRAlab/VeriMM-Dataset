`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg valid;
    wire [15:0] checksum;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .valid(valid),
        .checksum(checksum),
        .ready(ready)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Zero Word", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'h0000;
        valid = 1;
        @(posedge clk);
        valid = 0;

        wait(ready);
        #1;

        check_outputs(16'hffff, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Basic Addition (No Carry)", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'h1111; valid = 1;
        @(posedge clk);
        data_in = 16'h2222; valid = 1;
        @(posedge clk);
        valid = 0;
        wait(ready);
        #1;

        check_outputs(16'hcccc, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Simple End-Around Carry", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'hffff; valid = 1;
        @(posedge clk);
        data_in = 16'h0001; valid = 1;
        @(posedge clk);
        valid = 0;
        wait(ready);
        #1;

        check_outputs(16'hfffe, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Multi-word Header Stream", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'h4500; valid = 1;
        @(posedge clk);
        data_in = 16'h003c; valid = 1;
        @(posedge clk);
        data_in = 16'h0001; valid = 1;
        @(posedge clk);
        valid = 0;
        wait(ready);
        #1;

        check_outputs(16'hbac2, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Maximum Sum Wrap-around", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'hffff; valid = 1;
        @(posedge clk);
        data_in = 16'hffff; valid = 1;
        @(posedge clk);
        valid = 0;
        wait(ready);
        #1;

        check_outputs(16'h0000, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Bit-heavy Carry", test_num);
        rst = 1; valid = 0; data_in = 0;
        #20 rst = 0;
        @(posedge clk);
        data_in = 16'h8000; valid = 1;
        @(posedge clk);
        data_in = 16'h8000; valid = 1;
        @(posedge clk);
        data_in = 16'h0001; valid = 1;
        @(posedge clk);
        valid = 0;
        wait(ready);
        #1;

        check_outputs(16'hfffd, 1);
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
        input expected_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, ready=%b",
                         checksum, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, ready=%b",
                         expected_checksum, expected_ready);
                $display("  Got:      checksum=%h, ready=%b",
                         checksum, ready);
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
