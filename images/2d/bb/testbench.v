`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] granted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .granted(granted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            req = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            req = 4'b1111;

            @(posedge clk); #1;

            @(posedge clk); #1;

            @(posedge clk); #1;

            @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            req = 4'b1000;
            @(posedge clk); #1;
            req = 4'b1111;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            req = 4'b0101;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            req = 4'b0010;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("round_robin_arbiter Testbench");
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
        input [3:0] expected_granted;
        begin
            if (expected_granted === (expected_granted ^ granted ^ expected_granted)) begin
                $display("PASS");
                $display("  Outputs: granted=%h",
                         granted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: granted=%h",
                         expected_granted);
                $display("  Got:      granted=%h",
                         granted);
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
        $dumpvars(0,clk, req, rst, granted);
    end

endmodule
