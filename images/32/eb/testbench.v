`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg RE;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Write and Read Operation", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;


            D = 4'hA;
            WE = 1;
            #10;
            WE = 0;
            #10;


            RE = 1;
            #10;
            #1;

            check_outputs(4'hA);
            RE = 0; #10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Overwriting existing data", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;


            D = 4'h3; WE = 1; #10;
            WE = 0; #10;


            D = 4'h7; WE = 1; #10;
            WE = 0; #10;


            RE = 1;
            #10;
            #1;

            check_outputs(4'h7);
            RE = 0; #10;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Data persistence when WE is low", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;


            D = 4'hE; WE = 1; #10;
            WE = 0; #10;


            D = 4'h1; #10;


            RE = 1;
            #10;
            #1;

            check_outputs(4'hE);
            RE = 0; #10;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Output high-impedance or zero when RE is low", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;


            D = 4'h5; WE = 1; #10;
            WE = 0; #10;


            RE = 0;
            #10;



            #1;




            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Rapid Write-Read Sequence", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;


            D = 4'hF; WE = 1; #5;
            WE = 0; RE = 1; #5;

            #1;


            check_outputs(4'hF);
            RE = 0; #10;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All bits toggle (0 to 1)", test_num);

            WE = 0; RE = 0; D = 4'h0; #10;
            D = 4'h0; WE = 1; #10; WE = 0; #10;


            D = 4'hF; WE = 1; #10;
            WE = 0; RE = 1; #10;

            #1;


            check_outputs(4'hF);
            RE = 0; #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
