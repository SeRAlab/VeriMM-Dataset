`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg clk;
    reg load;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .D(D),
        .clk(clk),
        .load(load),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            D = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Parallel Load", test_num);
            reset_dut();
            D = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift Left (1 bit)", test_num);
            reset_dut();

            D = 16'h0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift Right (1 bit)", test_num);
            reset_dut();

            D = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_right = 1;
            @(posedge clk);
            #1 shift_right = 0;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Priority (Load over Shift)", test_num);
            reset_dut();
            D = 16'h5555;
            load = 1;
            shift_left = 1;
            shift_right = 1;
            @(posedge clk);
            #1 load = 0; shift_left = 0; shift_right = 0;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple Shift Lefts", test_num);
            reset_dut();
            D = 16'h000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1 shift_left = 0;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple Shift Rights", test_num);
            reset_dut();
            D = 16'hF000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_right = 1;
            repeat(4) @(posedge clk);
            #1 shift_right = 0;

            #1;


            check_outputs(16'h0F00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Shift out all bits", test_num);
            reset_dut();
            D = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(16) @(posedge clk);
            #1 shift_left = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_16bit Testbench");
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, rst, shift_left, shift_right, Q);
    end

endmodule
