`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [2:0] g;
    reg [2:0] p;
    wire [1:0] c;
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
        .gG(gG),
        .gP(gP)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All signals zero", test_num);
        p = 3'b000; g = 3'b000; cin = 1'b0;
        #1;

        check_outputs(2'b00, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Carry-in only (no propagate)", test_num);
        p = 3'b000; g = 3'b000; cin = 1'b1;
        #1;

        check_outputs(2'b00, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: cin propagates through stage 0", test_num);
        p = 3'b001; g = 3'b000; cin = 1'b1;
        #1;

        check_outputs(2'b01, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: cin propagates through stage 0 and 1", test_num);
        p = 3'b011; g = 3'b000; cin = 1'b1;
        #1;

        check_outputs(2'b11, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Group Propagate check", test_num);
        p = 3'b111; g = 3'b000; cin = 1'b1;
        #1;

        check_outputs(2'b11, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Generate from bit 0 only", test_num);
        p = 3'b000; g = 3'b001; cin = 1'b0;
        #1;

        check_outputs(2'b01, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Generate from bit 0 propagating to stage 1", test_num);
        p = 3'b010; g = 3'b001; cin = 1'b0;
        #1;

        check_outputs(2'b11, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Group Generate check (via bit 0)", test_num);
        p = 3'b110; g = 3'b001; cin = 1'b0;
        #1;

        check_outputs(2'b11, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Generate from bit 1", test_num);
        p = 3'b000; g = 3'b010; cin = 1'b0;
        #1;

        check_outputs(2'b10, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Group Generate check (via bit 1)", test_num);
        p = 3'b100; g = 3'b010; cin = 1'b0;
        #1;

        check_outputs(2'b10, 1'b1, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Generate from bit 2", test_num);
        p = 3'b000; g = 3'b100; cin = 1'b0;
        #1;

        check_outputs(2'b00, 1'b1, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex mix of p, g, cin", test_num);
        p = 3'b101; g = 3'b010; cin = 1'b1;




        #1;





        check_outputs(2'b11, 1'b1, 1'b0);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [1:0] expected_c;
        input expected_gG;
        input expected_gP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_gG === (expected_gG ^ gG ^ expected_gG) &&
                expected_gP === (expected_gP ^ gP ^ expected_gP)) begin
                $display("PASS");
                $display("  Outputs: c=%h, gG=%b, gP=%b",
                         c, gG, gP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, gG=%b, gP=%b",
                         expected_c, expected_gG, expected_gP);
                $display("  Got:      c=%h, gG=%b, gP=%b",
                         c, gG, gP);
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
