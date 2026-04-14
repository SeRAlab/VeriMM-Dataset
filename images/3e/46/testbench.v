`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] new_data;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .new_data(new_data),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            new_data <= 8'h00;
            @(posedge clk);
            load <= 0;
            new_data <= 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Synchronous Load 0xAA", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'hAA;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Single Left Shift (0x01 -> 0x02)", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'h01;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Four Left Shifts (0x0F -> 0xF0)", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'h0F;
            @(posedge clk);
            load <= 0;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Shift out all bits (0x80 -> 0x00)", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'h80;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Consecutive Load (Override shift)", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'h55;
            @(posedge clk);
            load <= 1;
            new_data <= 8'h33;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Shift 0xFF twice (0xFF -> 0xFC)", test_num);
            @(posedge clk);
            load <= 1;
            new_data <= 8'hFF;
            @(posedge clk);
            load <= 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        $dumpvars(0,clk, load, new_data, q);
    end

endmodule
