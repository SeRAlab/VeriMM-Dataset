`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg serial_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .serial_in(serial_in),
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
            load = 1;
            data_in = 8'h00;
            serial_in = 0;
            @(negedge clk);
            load = 0;
            data_in = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xAA", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(negedge clk);
            load = 0;

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Shift Left (Serial In = 1)", test_num);
            reset_dut();

            @(negedge clk);
            load = 0;
            serial_in = 1;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x01 and shift left 3 times", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(negedge clk);


            load = 0;
            serial_in = 0;
            repeat(3) @(negedge clk);

            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill register with 1s via serial_in", test_num);
            reset_dut();

            @(negedge clk);
            load = 0;
            serial_in = 1;
            repeat(8) @(negedge clk);

            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x80 and shift left once", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(negedge clk);


            load = 0;
            serial_in = 0;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in alternating 1010", test_num);
            reset_dut();

            @(negedge clk);
            load = 0;


            serial_in = 1; @(negedge clk);
            serial_in = 0; @(negedge clk);
            serial_in = 1; @(negedge clk);
            serial_in = 0; @(negedge clk);

            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Load Priority over Shift", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h55;
            serial_in = 1;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, data_in, load, serial_in, q);
    end

endmodule
