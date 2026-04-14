`timescale 1ns/1ps

module timer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [31:0] load_value;
    reg reset;
    wire [31:0] timer_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_32bit dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .timer_value(timer_value)
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
            load_value = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Increment", test_num);
            reset_dut();

            repeat (10) @(posedge clk);
            #2;

            #1;


            check_outputs(32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Functionality", test_num);
            reset_dut();

            load_value = 32'hA0A0_B0B0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            repeat (5) @(posedge clk);
            #2;


            #1;



            check_outputs(32'hA0A0_B0B0 + 32'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Wrap-around", test_num);
            reset_dut();

            load_value = 32'hFFFF_FFFE;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            repeat (3) @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous Load", test_num);
            reset_dut();

            load_value = 32'h1234_5678;
            load = 1;
            repeat (5) @(posedge clk);
            #2;


            #1;



            check_outputs(32'h1234_5678);
            load = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset Mid-cycle", test_num);
            reset_dut();

            repeat (5) @(posedge clk);
            #3;
            reset = 1;
            #1;

            #1;


            check_outputs(32'h0000_0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority over Load", test_num);
            reset_dut();

            load_value = 32'h5555_AAAA;
            load = 1;
            reset = 1;
            #10;

            #1;


            check_outputs(32'h0000_0000);
            reset = 0;
            load = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_32bit Testbench");
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
        input [31:0] expected_timer_value;
        begin
            if (expected_timer_value === (expected_timer_value ^ timer_value ^ expected_timer_value)) begin
                $display("PASS");
                $display("  Outputs: timer_value=%h",
                         timer_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_value=%h",
                         expected_timer_value);
                $display("  Got:      timer_value=%h",
                         timer_value);
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
        $dumpvars(0,clk, load, load_value, reset, timer_value);
    end

endmodule
