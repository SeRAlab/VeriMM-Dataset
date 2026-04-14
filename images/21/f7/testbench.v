`timescale 1ns/1ps

module divide_by_2_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_2 dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0", test_num);
            reset_dut();
            din = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 1 (Result should be 0)", test_num);
            reset_dut();
            din = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Sequence 1->0 (Value 2, Result 1)", test_num);
            reset_dut();


            din = 1;
            @(posedge clk);
            #2;


            din = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Sequence 1->1 (Value 3, Result 1)", test_num);
            reset_dut();

            din = 1;
            @(posedge clk);
            #2;

            din = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Edge Transition Check", test_num);
            reset_dut();

            din = 1;
            @(posedge clk);
            #2;

            din = 0;
            @(negedge clk);
            #2;




            #1;





            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stream Clearing Check", test_num);
            reset_dut();

            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            din = 0; @(posedge clk);
            #2;

            #1;


            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_2 Testbench");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
