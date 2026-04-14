`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg dir;
    reg load;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .dir(dir),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 1;
            data_in = 4'b0000;
            dir = 0;
            @(posedge clk);
            load = 0;
            $display("DUT Reset: Initialized to 0000");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Parallel Load 4'b1011", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Load 4'b0001 then shift left once", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b0001;
            @(posedge clk);
            load = 0;
            dir = 1;
            @(posedge clk);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Load 4'b1000 then shift right once", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1000;
            @(posedge clk);
            load = 0;
            dir = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Load 4'b0001 then shift left 3 times", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b0001;
            @(posedge clk);
            load = 0;
            dir = 1;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Load 4'b1000 then shift right 3 times", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1000;
            @(posedge clk);
            load = 0;
            dir = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Shift left 4'b1100 twice (bits lost)", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1100;
            @(posedge clk);
            load = 0;
            dir = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Shift right 4'b0011 twice (bits lost)", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b0011;
            @(posedge clk);
            load = 0;
            dir = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Load signal priority test while shifting", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            load = 1;
            dir = 1;
            data_in = 4'b0101;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Left shift then Right shift", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b0110;
            @(posedge clk);
            load = 0;
            dir = 1;
            @(posedge clk);
            dir = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Load 4'b1111", test_num);
            @(posedge clk);
            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b1111);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
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
        $dumpvars(0,clk, data_in, dir, load, data_out);
    end

endmodule
