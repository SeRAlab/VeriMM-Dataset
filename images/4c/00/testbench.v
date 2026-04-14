`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg load;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            d = 4'b0000;
            @(negedge clk);

            load = 1;
            d = 4'b0000;
            @(negedge clk);
            load = 0;
            $display("DUT Initialized");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Parallel Load", test_num);
            reset_dut();

            d = 4'b1011;
            load = 1;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Shift Left", test_num);
            reset_dut();


            d = 4'b0101;
            load = 1;
            @(negedge clk);


            load = 0;
            @(negedge clk);

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Shifts", test_num);
            reset_dut();

            d = 4'b0001;
            load = 1;
            @(negedge clk);

            load = 0;
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift Until Empty", test_num);
            reset_dut();

            d = 4'b1000;
            load = 1;
            @(negedge clk);

            load = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load Priority Over Shift", test_num);
            reset_dut();


            d = 4'b1111;
            load = 1;
            @(negedge clk);


            load = 0;
            @(negedge clk);


            d = 4'b0110;
            load = 1;
            @(negedge clk);

            #1;


            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Corner Case - All Ones", test_num);
            reset_dut();

            d = 4'b1111;
            load = 1;
            @(negedge clk);

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
        $display("shift_reg_4bit Testbench");
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
        $dumpvars(0,clk, d, load, q);
    end

endmodule
