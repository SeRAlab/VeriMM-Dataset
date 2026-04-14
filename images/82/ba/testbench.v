`timescale 1ns/1ps

module mux_2_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2_to_1 dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select in0 with standard values", test_num);
        in0 = 8'hA5;
        in1 = 8'h5A;
        sel = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select in1 with standard values", test_num);
        in0 = 8'hA5;
        in1 = 8'h5A;
        sel = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select in0 with all zeros vs all ones", test_num);
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select in1 with all zeros vs all ones", test_num);
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select in0 with arbitrary pattern", test_num);
        in0 = 8'h12;
        in1 = 8'h34;
        sel = 1'b0;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select in1 with arbitrary pattern", test_num);
        in0 = 8'h12;
        in1 = 8'h34;
        sel = 1'b1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Check transparency of in0 changes when sel=0", test_num);
        in0 = 8'hDE;
        in1 = 8'hAD;
        sel = 1'b0;
        #1;

        check_outputs(8'hDE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Check transparency of in1 changes when sel=1", test_num);
        in0 = 8'hBE;
        in1 = 8'hEF;
        sel = 1'b1;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2_to_1 Testbench");
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
        input [7:0] expected_out;
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
