`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] map_update;
    reg [1:0] position_update;
    reg reset;
    wire [1:0] current_position;
    wire [31:0] map;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .map_update(map_update),
        .position_update(position_update),
        .reset(reset),
        .current_position(current_position),
        .map(map)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            map_update = 5'd0;
            position_update = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Move Right", test_num);
            reset_dut();
            position_update = 2'b10;
            map_update = 5'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 32'h40000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Move Left (Wrap-around)", test_num);
            reset_dut();
            position_update = 2'b01;
            map_update = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Move Forward", test_num);
            reset_dut();
            position_update = 2'b11;
            map_update = 5'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 32'h00000020);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Map High Index", test_num);
            reset_dut();
            position_update = 2'b00;
            map_update = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Cumulative Mapping", test_num);
            reset_dut();
            position_update = 2'b00;

            map_update = 5'd1; @(posedge clk); #1;
            map_update = 5'd2; @(posedge clk); #1;
            map_update = 5'd3; @(posedge clk); #1;


            #1;



            check_outputs(2'b00, 32'h0000000E);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multi-step Movement", test_num);
            reset_dut();
            map_update = 5'd0;

            position_update = 2'b10; @(posedge clk); #1;
            position_update = 2'b10; @(posedge clk); #1;
            position_update = 2'b10; @(posedge clk); #1;

            #1;


            check_outputs(2'b11, 32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Comprehensive SLAM step", test_num);
            reset_dut();


            position_update = 2'b10; map_update = 5'd10; @(posedge clk); #1;


            position_update = 2'b11; map_update = 5'd20; @(posedge clk); #1;



            #1;




            check_outputs(2'b10, 32'h00100400);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        input [1:0] expected_current_position;
        input [31:0] expected_map;
        begin
            if (expected_current_position === (expected_current_position ^ current_position ^ expected_current_position) &&
                expected_map === (expected_map ^ map ^ expected_map)) begin
                $display("PASS");
                $display("  Outputs: current_position=%h, map=%h",
                         current_position, map);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_position=%h, map=%h",
                         expected_current_position, expected_map);
                $display("  Got:      current_position=%h, map=%h",
                         current_position, map);
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
        $dumpvars(0,clk, map_update, position_update, reset, current_position, map);
    end

endmodule
