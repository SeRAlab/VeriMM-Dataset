`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg load;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            d = 4'b0000;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load (Data 4'b1011)", test_num);
            reset_dut();

            @(negedge clk);
            d = 4'b1011;
            load = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Shift Left", test_num);
            reset_dut();


            @(negedge clk);
            d = 4'b0001;
            load = 1;
            @(posedge clk);


            @(negedge clk);
            load = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Triple Shift Left", test_num);
            reset_dut();


            @(negedge clk);
            d = 4'b1100;
            load = 1;
            @(posedge clk);


            @(negedge clk);
            load = 0;
            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Load and Shift", test_num);
            reset_dut();


            @(negedge clk);
            d = 4'b0101;
            load = 1;
            @(posedge clk);


            @(negedge clk);
            load = 0;
            @(posedge clk);


            @(negedge clk);
            d = 4'b1111;
            load = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Reset Mid-Cycle", test_num);
            reset_dut();


            @(negedge clk);
            d = 4'b1010;
            load = 1;
            @(posedge clk);


            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(4'b0000);


            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRegister Testbench");
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
