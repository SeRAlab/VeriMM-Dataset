`timescale 1ns/1ps

module mux_3input_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] sel;
    reg x;
    reg y;
    reg z;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_3input dut (
        .sel(sel),
        .x(x),
        .y(y),
        .z(z),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select X (sel=0), X=0", test_num);
        sel = 2'b00; x = 0; y = 1; z = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select X (sel=0), X=1", test_num);
        sel = 2'b00; x = 1; y = 0; z = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Y (sel=1), Y=0", test_num);
        sel = 2'b01; x = 1; y = 0; z = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Y (sel=1), Y=1", test_num);
        sel = 2'b01; x = 0; y = 1; z = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select Z (sel=2), Z=0", test_num);
        sel = 2'b10; x = 1; y = 1; z = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select Z (sel=2), Z=1", test_num);
        sel = 2'b10; x = 0; y = 0; z = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select X (sel=0), Toggle other inputs", test_num);
        sel = 2'b00; x = 1; y = 1; z = 1;
        #1;
        y = 0; z = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select Y (sel=1), Toggle other inputs", test_num);
        sel = 2'b01; x = 1; y = 1; z = 1;
        #1;
        x = 0; z = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Select Z (sel=2), Toggle other inputs", test_num);
        sel = 2'b10; x = 1; y = 1; z = 1;
        #1;
        x = 0; y = 0;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_3input Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
