`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg valid;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        valid = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Valid data input assertion", test_num);
        reset_dut();

        data_in = 32'hDEADBEEF;
        valid = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);

        valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Idle state (valid=0)", test_num);
        reset_dut();

        data_in = 32'hCAFEBABE;
        valid = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset priority during valid signal", test_num);
        reset_dut();

        valid = 1;
        data_in = 32'h12345678;
        @(posedge clk);

        rst = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
        rst = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Consecutive transfers", test_num);
        reset_dut();


        data_in = 32'hAAAA_AAAA;
        valid = 1;
        @(posedge clk);


        data_in = 32'hBBBB_BBBB;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
        valid = 0;
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Valid toggle", test_num);
        reset_dut();

        valid = 1;
        data_in = 32'h5555_AAAA;
        @(posedge clk);

        valid = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_ready;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ready=%b",
                         ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b",
                         expected_ready);
                $display("  Got:      ready=%b",
                         ready);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, rst, valid, ready);
    end

endmodule
