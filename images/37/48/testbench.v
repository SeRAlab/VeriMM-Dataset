`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] gnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .gnt(gnt)
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
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Highest priority (Ch 0) active...");
        reset_dut();
        req = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Lowest priority (Ch 3) active...");
        reset_dut();
        req = 4'b1000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Ch 0 and Ch 1 active, Ch 0 should win...");
        reset_dut();
        req = 4'b0011;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Ch 1 and Ch 3 active, Ch 1 should win...");
        reset_dut();
        req = 4'b1010;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: All channels active, Ch 0 should win...");
        reset_dut();
        req = 4'b1111;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: No channels active...");
        reset_dut();
        req = 4'b0000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Middle priority (Ch 2) active...");
        reset_dut();
        req = 4'b0100;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Reset signal test...");
        reset_dut();
        rst = 1;
        req = 4'b1111;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [3:0] expected_gnt;
        begin
            if (expected_gnt === (expected_gnt ^ gnt ^ expected_gnt)) begin
                $display("PASS");
                $display("  Outputs: gnt=%h",
                         gnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt=%h",
                         expected_gnt);
                $display("  Got:      gnt=%h",
                         gnt);
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
        $dumpvars(0,clk, req, rst, gnt);
    end

endmodule
