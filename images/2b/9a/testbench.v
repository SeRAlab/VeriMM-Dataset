`timescale 1ns/1ps

module kruskal_mst_tb;

    // Testbench signals (combinational circuit)
    reg [79:0] edges;
    wire [79:0] mst_edges;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kruskal_mst dut (
        .edges(edges),
        .mst_edges(mst_edges)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Triangle Graph", test_num);


            edges = {16'h0000, 16'h0000, 16'h020F, 16'h1205, 16'h010A};

            #1;


            check_outputs({16'h0000, 16'h0000, 16'h0000, 16'h1205, 16'h010A});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4-Node Square with Diagonal", test_num);

            edges = {16'h0205, 16'h3004, 16'h2303, 16'h1202, 16'h0101};

            #1;


            check_outputs({16'h0000, 16'h0000, 16'h2303, 16'h1202, 16'h0101});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disconnected Components", test_num);

            edges = {16'h0000, 16'h0000, 16'h0000, 16'h2305, 16'h0105};
            #1;

            check_outputs({16'h0000, 16'h0000, 16'h0000, 16'h2305, 16'h0105});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: K4 Connectivity", test_num);

            edges = {16'h1201, 16'h0101, 16'h231E, 16'h1314, 16'h030A};


            #1;



            check_outputs({16'h1201, 16'h0101, 16'h0000, 16'h0000, 16'h030A});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Edges", test_num);

            edges = {16'h0000, 16'h0000, 16'h011E, 16'h010A, 16'h0114};

            #1;


            check_outputs({16'h0000, 16'h0000, 16'h0000, 16'h010A, 16'h0000});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kruskal_mst Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [79:0] expected_mst_edges;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mst_edges === (expected_mst_edges ^ mst_edges ^ expected_mst_edges)) begin
                $display("PASS");
                $display("  Outputs: mst_edges=%h",
                         mst_edges);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mst_edges=%h",
                         expected_mst_edges);
                $display("  Got:      mst_edges=%h",
                         mst_edges);
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
