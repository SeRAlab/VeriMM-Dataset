`timescale 1ns/1ps

module counter8bit_bidirectional_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [7:0] load_val;
    reg rst;
    reg up_down;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter8bit_bidirectional dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .up_down(up_down),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            load = 0;
            load_val = 0;
            up_down = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load Operation");
            reset_dut();
            load = 1;
            load_val = 8'hA5;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Increment (Up)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Decrement (Down)");
            reset_dut();
            load = 1;
            load_val = 8'h20;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            up_down = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h1B);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable Inhibition");
            reset_dut();
            en = 0;
            up_down = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Roll-over (FF to 00)");
            reset_dut();
            load = 1;
            load_val = 8'hFE;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            up_down = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Roll-under (00 to FF)");
            reset_dut();

            en = 1;
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load Priority");
            reset_dut();
            en = 1;
            up_down = 1;
            load = 1;
            load_val = 8'hCC;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hCC);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Sequence (Load 0x10 -> Up 2 -> Down 4)");
            reset_dut();
            load = 1;
            load_val = 8'h10;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            up_down = 1;
            repeat(2) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(8'h0E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter8bit_bidirectional Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, en, load, load_val, rst, up_down, q);
    end

endmodule
