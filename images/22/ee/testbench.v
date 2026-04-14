`timescale 1ns/1ps

module robot_location_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] move;
    reg reset;
    wire [1:0] location;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_location_fsm dut (
        .clk(clk),
        .move(move),
        .reset(reset),
        .location(location)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        move = 2'b00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset State Initialization", test_num);
        reset_dut();
        #1;

        check_outputs(LOC_00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Move Right from (0,0)", test_num);
        reset_dut();
        move = MOVE_RIGHT;
        @(posedge clk);
        #1 #1;
 check_outputs(LOC_10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Move Up from (0,0)", test_num);
        reset_dut();
        move = MOVE_UP;
        @(posedge clk);
        #1 #1;
 check_outputs(LOC_01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Path (0,0) -> (1,0) -> (1,1)", test_num);
        reset_dut();
        move = MOVE_RIGHT;
        @(posedge clk);
        #1 move = MOVE_UP;
        @(posedge clk);
        #1 #1;
 check_outputs(LOC_11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Left from (0,0)", test_num);
        reset_dut();
        move = MOVE_LEFT;
        @(posedge clk);
        #1 #1;
 check_outputs(LOC_00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Down from (0,0)", test_num);
        reset_dut();
        move = MOVE_DOWN;
        @(posedge clk);
        #1 #1;
 check_outputs(LOC_00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Right from (1,1)", test_num);
        reset_dut();
        move = MOVE_RIGHT; @(posedge clk);
        #1 move = MOVE_UP; @(posedge clk);
        #1 move = MOVE_RIGHT; @(posedge clk);
        #1 #1;
 check_outputs(LOC_11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Path (0,0) -> (1,0) -> (0,0)", test_num);
        reset_dut();
        move = MOVE_RIGHT; @(posedge clk);
        #1 move = MOVE_LEFT; @(posedge clk);
        #1 #1;
 check_outputs(LOC_00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complete Grid Loop", test_num);
        reset_dut();
        move = MOVE_RIGHT; @(posedge clk);
        #1 move = MOVE_UP; @(posedge clk);
        #1 move = MOVE_LEFT; @(posedge clk);
        #1 move = MOVE_DOWN; @(posedge clk);
        #1 #1;
 check_outputs(LOC_00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Move Left from Top Right (1,1)", test_num);
        reset_dut();
        move = MOVE_RIGHT; @(posedge clk);
        #1 move = MOVE_UP; @(posedge clk);
        #1 move = MOVE_LEFT; @(posedge clk);
        #1 #1;
 check_outputs(LOC_01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_location_fsm Testbench");
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
        input [1:0] expected_location;
        begin
            if (expected_location === (expected_location ^ location ^ expected_location)) begin
                $display("PASS");
                $display("  Outputs: location=%h",
                         location);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: location=%h",
                         expected_location);
                $display("  Got:      location=%h",
                         location);
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
        $dumpvars(0,clk, move, reset, location);
    end

endmodule
