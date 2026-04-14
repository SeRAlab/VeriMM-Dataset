`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg data_in;
    reg we;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        addr = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Write '1' to addr 0");
        reset_dut();
        test_num = test_num + 1;


        we = 1;
        addr = 3'b000;
        data_in = 1'b1;
        @(posedge clk);
        #1;


        we = 0;
        addr = 3'b000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Write '0' to addr 7");
        reset_dut();
        test_num = test_num + 1;


        we = 1;
        addr = 3'b111;
        data_in = 1'b0;
        @(posedge clk);
        #1;


        we = 0;
        addr = 3'b111;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Overwrite addr 4 (1 then 0)");
        reset_dut();
        test_num = test_num + 1;


        we = 1; addr = 3'd4; data_in = 1'b1;
        @(posedge clk); #1;


        we = 1; addr = 3'd4; data_in = 1'b0;
        @(posedge clk); #1;


        we = 0; addr = 3'd4;
        @(posedge clk); #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: WE=0 Write Inhibition Test");
        reset_dut();
        test_num = test_num + 1;


        we = 1; addr = 3'd2; data_in = 1'b1;
        @(posedge clk); #1;


        we = 0; addr = 3'd2; data_in = 1'b0;
        @(posedge clk); #1;


        we = 0; addr = 3'd2;
        @(posedge clk); #1;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Multi-address persistence (addr 1 and 6)");
        reset_dut();
        test_num = test_num + 1;


        we = 1; addr = 3'd1; data_in = 1'b1;
        @(posedge clk); #1;


        we = 1; addr = 3'd6; data_in = 1'b0;
        @(posedge clk); #1;


        we = 0; addr = 3'd1;
        @(posedge clk); #1;
        if (data_out !== 1'b1) begin
            $display("Fail at addr 1 check");
        end


        we = 0; addr = 3'd6;
        @(posedge clk); #1;

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
        $display("dram_cell Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
