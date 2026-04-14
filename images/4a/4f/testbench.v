`timescale 1ns/1ps

module verified_shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg rst;
    reg shift;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_shift_reg_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift(shift),
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
            load = 0;
            shift = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset", test_num);
            reset_dut();


            #1;



            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify Parallel Load", test_num);
            reset_dut();

            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Shift Left (1 bit)", test_num);
            reset_dut();


            load = 1;
            data_in = 4'b0011;
            @(posedge clk);
            #1;


            load = 0;
            shift = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify Shift Right (1 bit)", test_num);
            reset_dut();


            load = 1;
            data_in = 4'b1100;
            @(posedge clk);
            #1;


            load = 0;
            shift = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Multiple Shift Lefts", test_num);
            reset_dut();


            load = 1;
            data_in = 4'b1001;
            @(posedge clk);
            #1;


            load = 0;
            shift = 1;
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify Multiple Shift Rights", test_num);
            reset_dut();


            load = 1;
            data_in = 4'b1001;
            @(posedge clk);
            #1;


            load = 0;
            shift = 0;
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify Load Priority over Shift", test_num);
            reset_dut();


            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;


            load = 1;
            data_in = 4'b1010;
            shift = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Verify Shift Right to 0", test_num);
            reset_dut();

            load = 1;
            data_in = 4'b0001;
            @(posedge clk);
            #1;

            load = 0;
            shift = 0;
            @(posedge clk);
            #1;

            #1;


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
        $display("verified_shift_reg_4bit Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, rst, shift, q);
    end

endmodule
