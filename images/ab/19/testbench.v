`timescale 1ns/1ps

module reg24_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [23:0] data;
    reg load;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg24 dut (
        .clk(clk),
        .clr(clr),
        .data(data),
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
            @(negedge clk);
            clr = 1;
            load = 0;
            data = 0;
            @(negedge clk);
            clr = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Synchronous Load (0xA5A5A5)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            clr = 0;
            data = 24'hA5A5A5;

            @(negedge clk);
            load = 0;

            #1;


            check_outputs(24'hA5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load All Ones (0xFFFFFF)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            clr = 0;
            data = 24'hFFFFFF;

            @(negedge clk);
            load = 0;

            #1;


            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Register Data Hold when load is low", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            data = 24'h123456;
            @(negedge clk);


            load = 0;
            data = 24'hABCDEF;
            @(negedge clk);

            #1;


            check_outputs(24'h123456);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Clear", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            data = 24'h654321;
            @(negedge clk);


            load = 0;
            clr = 1;
            @(negedge clk);
            clr = 0;

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (clr and load both high)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            clr = 1;
            data = 24'hBEEFCA;

            @(negedge clk);
            load = 0;
            clr = 0;



            #1;




            check_outputs(24'h000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load and then immediately Clear", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data = 24'h112233;
            @(negedge clk);
            load = 0;
            clr = 1;
            @(negedge clk);
            clr = 0;

            #1;


            check_outputs(24'h000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg24 Testbench");
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
        input [23:0] expected_q;
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
        $dumpvars(0,clk, clr, data, load, q);
    end

endmodule
