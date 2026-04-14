`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] g;
    reg [3:0] p;
    wire [3:0] c;
    wire cout;
    wire gG;
    wire gP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .g(g),
        .p(p),
        .c(c),
        .cout(cout),
        .gG(gG),
        .gP(gP)
    );
    task testcase001;

    begin
        test_num = 1;

        g = 4'b0000; p = 4'b0000; cin = 1'b0;

        #1;


        check_outputs(4'h0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        g = 4'b0000; p = 4'b1111; cin = 1'b1;

        #1;


        check_outputs(4'hf, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        g = 4'b0000; p = 4'b1111; cin = 1'b0;

        #1;


        check_outputs(4'h0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        g = 4'b1111; p = 4'b0000; cin = 1'b0;

        #1;


        check_outputs(4'hf, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        g = 4'b0001; p = 4'b1110; cin = 1'b0;


        #1;



        check_outputs(4'hf, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        g = 4'b1000; p = 4'b0111; cin = 1'b0;

        #1;


        check_outputs(4'h8, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        g = 4'b0010; p = 4'b1101; cin = 1'b1;




        #1;





        check_outputs(4'he, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        g = 4'b0100; p = 4'b1011; cin = 1'b1;







        #1;








        check_outputs(4'hf, 1'b1, 1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_c;
        input expected_cout;
        input expected_gG;
        input expected_gP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_gG === (expected_gG ^ gG ^ expected_gG) &&
                expected_gP === (expected_gP ^ gP ^ expected_gP)) begin
                $display("PASS");
                $display("  Outputs: c=%h, cout=%b, gG=%b, gP=%b",
                         c, cout, gG, gP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, cout=%b, gG=%b, gP=%b",
                         expected_c, expected_cout, expected_gG, expected_gP);
                $display("  Got:      c=%h, cout=%b, gG=%b, gP=%b",
                         c, cout, gG, gP);
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
