`timescale 1ns/1ps

module mux_2to1_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_32bit dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (0xAAAAAAAA)", test_num);
            in0 = 32'hAAAA_AAAA;
            in1 = 32'h5555_5555;
            sel = 0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (0x55555555)", test_num);
            in0 = 32'hAAAA_AAAA;
            in1 = 32'h5555_5555;
            sel = 1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (All Zeros)", test_num);
            in0 = 32'h0000_0000;
            in1 = 32'hFFFF_FFFF;
            sel = 0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (All Ones)", test_num);
            in0 = 32'h0000_0000;
            in1 = 32'hFFFF_FFFF;
            sel = 1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (Hex Pattern 1)", test_num);
            in0 = 32'h1234_5678;
            in1 = 32'h8765_4321;
            sel = 0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (Hex Pattern 2)", test_num);
            in0 = 32'h1234_5678;
            in1 = 32'h8765_4321;
            sel = 1;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_32bit Testbench");
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
