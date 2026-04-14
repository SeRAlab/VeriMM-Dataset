`timescale 1ns/1ps

module min_weight_edge_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] edge0;
    reg [3:0] edge1;
    reg [3:0] edge2;
    reg [3:0] edge3;
    reg [3:0] edge4;
    wire [3:0] min_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    min_weight_edge dut (
        .edge0(edge0),
        .edge1(edge1),
        .edge2(edge2),
        .edge3(edge3),
        .edge4(edge4),
        .min_edge(min_edge)
    );
    task testcase001;

    begin
        edge0 = 4'd2; edge1 = 4'd5; edge2 = 4'd8; edge3 = 4'd10; edge4 = 4'd15;
        $display("Test 001: edge0 is min (2)");
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase002;

    begin
        edge0 = 4'd7; edge1 = 4'd1; edge2 = 4'd9; edge3 = 4'd3; edge4 = 4'd5;
        $display("Test 002: edge1 is min (1)");
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        edge0 = 4'd12; edge1 = 4'd11; edge2 = 4'd0; edge3 = 4'd14; edge4 = 4'd15;
        $display("Test 003: edge2 is min (0)");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        edge0 = 4'd4; edge1 = 4'd6; edge2 = 4'd8; edge3 = 4'd3; edge4 = 4'd7;
        $display("Test 004: edge3 is min (3)");
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase005;

    begin
        edge0 = 4'd10; edge1 = 4'd13; edge2 = 4'd11; edge3 = 4'd9; edge4 = 4'd2;
        $display("Test 005: edge4 is min (2)");
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        edge0 = 4'd5; edge1 = 4'd5; edge2 = 4'd5; edge3 = 4'd5; edge4 = 4'd5;
        $display("Test 006: All values equal (5)");
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase007;

    begin
        edge0 = 4'd3; edge1 = 4'd8; edge2 = 4'd3; edge3 = 4'd10; edge4 = 4'd3;
        $display("Test 007: Multiple minimum values (3)");
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase008;

    begin
        edge0 = 4'd1; edge1 = 4'd2; edge2 = 4'd3; edge3 = 4'd4; edge4 = 4'd5;
        $display("Test 008: Ascending values (1)");
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase009;

    begin
        edge0 = 4'd9; edge1 = 4'd8; edge2 = 4'd7; edge3 = 4'd6; edge4 = 4'd5;
        $display("Test 009: Descending values (5)");
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase010;

    begin
        edge0 = 4'hf; edge1 = 4'hf; edge2 = 4'hf; edge3 = 4'hf; edge4 = 4'he;
        $display("Test 010: Near maximum values (14)");
        #1;

        check_outputs(4'he);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("min_weight_edge Testbench");
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
        input [3:0] expected_min_edge;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min_edge === (expected_min_edge ^ min_edge ^ expected_min_edge)) begin
                $display("PASS");
                $display("  Outputs: min_edge=%h",
                         min_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_edge=%h",
                         expected_min_edge);
                $display("  Got:      min_edge=%h",
                         min_edge);
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

endmodule
