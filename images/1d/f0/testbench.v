`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] chan1_addr;
    reg chan1_en;
    reg [7:0] chan2_addr;
    reg chan2_en;
    reg clk;
    reg reset;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .chan1_addr(chan1_addr),
        .chan1_en(chan1_en),
        .chan2_addr(chan2_addr),
        .chan2_en(chan2_en),
        .clk(clk),
        .reset(reset),
        .data_out(data_out),
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
            chan1_en = 0;
            chan2_en = 0;
            chan1_addr = 0;
            chan2_addr = 0;
            start = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Channel 1 basic transfer");
            reset_dut();
            chan1_en = 1;
            chan1_addr = 8'hA1;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA1, 1'b1);
            start = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Channel 2 basic transfer");
            reset_dut();
            chan2_en = 1;
            chan2_addr = 8'hB2;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hB2, 1'b1);
            start = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Priority check (Both enabled)");
            reset_dut();
            chan1_en = 1;
            chan1_addr = 8'h11;
            chan2_en = 1;
            chan2_addr = 8'h22;
            start = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h11, 1'b1);
            start = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: No channel enabled");
            reset_dut();
            chan1_en = 0;
            chan2_en = 0;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0);
            start = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Sequential transfers");
            reset_dut();


            chan1_en = 1;
            chan1_addr = 8'hC3;
            start = 1;
            @(posedge clk);
            #2;


            chan1_en = 0;
            chan2_en = 1;
            chan2_addr = 8'hD4;
            start = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hD4, 1'b1);
            start = 0;
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,chan1_addr, chan1_en, chan2_addr, chan2_en, clk, reset, data_out, done);
    end

endmodule
