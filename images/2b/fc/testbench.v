`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg valid;
    wire [15:0] checksum;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .checksum(checksum),
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
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Simple two-word sum", test_num);

            valid = 1;
            data_in = 16'h1111;
            @(posedge clk);
            data_in = 16'h2222;
            @(posedge clk);
            valid = 0;
            data_in = 16'h0000;


            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'hCCCC, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Sum with end-around carry", test_num);

            valid = 1;
            data_in = 16'hF000;
            @(posedge clk);
            data_in = 16'hF000;
            @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h1FFE, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Multi-word packet header fragment", test_num);

            valid = 1;
            data_in = 16'h4500; @(posedge clk);
            data_in = 16'h003C; @(posedge clk);
            data_in = 16'h1C46; @(posedge clk);
            data_in = 16'h4000; @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h5E7D, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Maximum values", test_num);

            valid = 1;
            data_in = 16'hFFFF; @(posedge clk);
            data_in = 16'hFFFF; @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: All zeros", test_num);

            valid = 1;
            data_in = 16'h0000; @(posedge clk);
            data_in = 16'h0000; @(posedge clk);
            valid = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 1'b1);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, rst, valid, checksum, ready);
    end

endmodule
