`timescale 1ns/1ps

module voltage_level_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg vref;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_level_shifter dut (
        .in(in),
        .vref(vref),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs < vref (in=4'b0000, vref=1)", test_num);
        in = 4'b0000;
        vref = 1'b1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs > vref (in=4'b1111, vref=0)", test_num);
        in = 4'b1111;
        vref = 1'b0;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs == vref (in=4'b0000, vref=0)", test_num);
        in = 4'b0000;
        vref = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs == vref (in=4'b1111, vref=1)", test_num);
        in = 4'b1111;
        vref = 1'b1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs (in=4'b1010, vref=0)", test_num);
        in = 4'b1010;
        vref = 1'b0;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs (in=4'b1100, vref=1)", test_num);
        in = 4'b1100;
        vref = 1'b1;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking bit pattern (in=4'b0001, vref=0)", test_num);
        in = 4'b0001;
        vref = 1'b0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern (in=4'b0101, vref=0)", test_num);
        in = 4'b0101;
        vref = 1'b0;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_level_shifter Testbench");
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
        input [3:0] expected_out;
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
