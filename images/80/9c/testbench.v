`timescale 1ns/1ps

module new_module_10_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg g;
    wire h;
    wire i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_10 dut (
        .clock(clock),
        .g(g),
        .h(h),
        .i(i)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            g = 0;


            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking transition after 1 clock edge with g=1", test_num);
            reset_dut();

            @(posedge clock);
            g <= 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking transition after 2 clock edges with g=1", test_num);
            reset_dut();

            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking transition after 3 clock edges with g=1", test_num);
            reset_dut();

            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking transition after 4 clock edges with g=1", test_num);
            reset_dut();

            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking transition after 5 clock edges with g=1", test_num);
            reset_dut();

            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking output hold when g=0", test_num);
            reset_dut();


            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); g <= 1;
            @(posedge clock); #1;


            g <= 0;
            @(posedge clock);
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking long-term toggle loop behavior", test_num);
            reset_dut();


            repeat(10) begin
                @(posedge clock); g <= 1;
            end
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_10 Testbench");
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
        input expected_h;
        input expected_i;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_i === (expected_i ^ i ^ expected_i)) begin
                $display("PASS");
                $display("  Outputs: h=%b, i=%b",
                         h, i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%b, i=%b",
                         expected_h, expected_i);
                $display("  Got:      h=%b, i=%b",
                         h, i);
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
        $dumpvars(0,clock, g, h, i);
    end

endmodule
