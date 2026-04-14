`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg shift_en;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift_en(shift_en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            shift_en = 0;
            data_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Synchronous Reset", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Shift Left Single Bit (0x01 -> 0x02)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'h01;
            load = 1;
            @(negedge clk);

            load = 0;
            shift_en = 1;
            @(negedge clk);
            shift_en = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multi-bit Shift Left (0x0F shift 4 times -> 0xF0)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'h0F;
            load = 1;
            @(negedge clk);

            load = 0;
            shift_en = 1;
            repeat(4) @(negedge clk);
            shift_en = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Shift Left Overflow (0x80 -> 0x00)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'h80;
            load = 1;
            @(negedge clk);

            load = 0;
            shift_en = 1;
            @(negedge clk);
            shift_en = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Load Priority Over Shift", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'h55;
            load = 1;
            shift_en = 1;
            @(negedge clk);
            load = 0;
            shift_en = 0;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Hold Value (Enable=0, Load=0)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'hAA;
            load = 1;
            @(negedge clk);

            load = 0;
            shift_en = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Reset Priority Over Load/Shift", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'hFF;
            load = 1;
            @(negedge clk);

            reset = 1;
            load = 1;
            shift_en = 1;
            data_in = 8'hAA;
            @(negedge clk);
            reset = 0;
            load = 0;
            shift_en = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, reset, shift_en, q);
    end

endmodule
