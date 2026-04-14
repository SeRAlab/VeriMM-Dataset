`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg valid;
    wire [15:0] checksum;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .checksum(checksum),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic two-word calculation", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'h1111;
            @(posedge clk);
            data_in = 16'h2222;
            @(posedge clk);
            valid = 0;
            data_in = 0;

            wait(done);
            #1;

            check_outputs(16'hCCCC, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry wrap-around", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hF000;
            @(posedge clk);
            data_in = 16'hF000;
            @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(16'h1FFE, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero data input", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'h0000;
            @(posedge clk);
            data_in = 16'h0000;
            @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones data", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-word stream", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'h4500;
            @(posedge clk);
            data_in = 16'h0030;
            @(posedge clk);
            data_in = 16'h4422;
            @(posedge clk);
            data_in = 16'h4000;
            @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(16'h36AD, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Repeated max values", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(16'h0000, 1'b1);
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
        input expected_done;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, done=%b",
                         checksum, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, done=%b",
                         expected_checksum, expected_done);
                $display("  Got:      checksum=%h, done=%b",
                         checksum, done);
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
        $dumpvars(0,clk, data_in, reset, valid, checksum, done);
    end

endmodule
