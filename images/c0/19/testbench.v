`timescale 1ns/1ps

module xy_calculate_tb;

    // Testbench signals (sequential circuit)
    reg RST;
    reg clk;
    reg east;
    reg knob;
    reg north;
    reg south;
    reg west;
    wire [2:0] X;
    wire [2:0] Y;
    wire enter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xy_calculate dut (
        .RST(RST),
        .clk(clk),
        .east(east),
        .knob(knob),
        .north(north),
        .south(south),
        .west(west),
        .X(X),
        .Y(Y),
        .enter(enter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RST = 1;
            east = 0;
            west = 0;
            north = 0;
            south = 0;
            knob = 0;
            @(posedge clk);
            #1;
            RST = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic increment (East/North)", test_num);
            reset_dut();


            east = 1;
            @(posedge clk);
            @(posedge clk);
            east = 0;


            north = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            north = 0;

            #1;
            #1;

            check_outputs(3'd2, 3'd3, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic decrement (West/South from origin)", test_num);
            reset_dut();


            west = 1;
            @(posedge clk);
            west = 0;


            south = 1;
            @(posedge clk);
            @(posedge clk);
            south = 0;

            #1;
            #1;

            check_outputs(3'd7, 3'd6, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Knob/Enter signal check", test_num);
            reset_dut();


            east = 1; north = 1;
            @(posedge clk);
            east = 0; north = 0;


            knob = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(3'd1, 3'd1, 1'b1);
            knob = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Wrap-around (7 to 0)", test_num);
            reset_dut();


            east = 1;
            repeat(8) @(posedge clk);
            east = 0;

            #1;
            #1;

            check_outputs(3'd0, 3'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opposing directions (East + West)", test_num);
            reset_dut();




            east = 1;
            west = 1;
            @(posedge clk);
            east = 0;
            west = 0;

            #1;

            #1;


            check_outputs(3'd0, 3'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex pathing", test_num);
            reset_dut();


            east = 1; repeat(3) @(posedge clk); east = 0;
            west = 1; repeat(1) @(posedge clk); west = 0;
            north = 1; repeat(5) @(posedge clk); north = 0;
            south = 1; repeat(2) @(posedge clk); south = 0;

            #1;


            #1;



            check_outputs(3'd2, 3'd3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            east = 1; north = 1;
            repeat(4) @(posedge clk);


            RST = 1;
            @(posedge clk);
            RST = 0;
            east = 0; north = 0;

            #1;
            #1;

            check_outputs(3'd0, 3'd0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xy_calculate Testbench");
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
        input [2:0] expected_X;
        input [2:0] expected_Y;
        input expected_enter;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_enter === (expected_enter ^ enter ^ expected_enter)) begin
                $display("PASS");
                $display("  Outputs: X=%h, Y=%h, enter=%b",
                         X, Y, enter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h, Y=%h, enter=%b",
                         expected_X, expected_Y, expected_enter);
                $display("  Got:      X=%h, Y=%h, enter=%b",
                         X, Y, enter);
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
        $dumpvars(0,RST, clk, east, knob, north, south, west, X, Y, enter);
    end

endmodule
