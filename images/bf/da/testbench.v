`timescale 1ns/1ps

module zzadd48_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [47:0] rs1_data;
    reg [47:0] rs2_data;
    wire [47:0] adder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd48 dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .adder_out(adder_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All Zeros", test_num);
        rs1_data = 48'h0;
        rs2_data = 48'h0;
        cin = 0;
        #1;

        check_outputs(48'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Carry-in Only", test_num);
        rs1_data = 48'h0;
        rs2_data = 48'h0;
        cin = 1;
        #1;

        check_outputs(48'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Simple Addition", test_num);
        rs1_data = 48'h123456789ABC;
        rs2_data = 48'h000000000001;
        cin = 0;
        #1;

        check_outputs(48'h123456789ABD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Nibble Carry Propagation", test_num);
        rs1_data = 48'h0000_0000_FFFF;
        rs2_data = 48'h0000_0000_0001;
        cin = 0;
        #1;

        check_outputs(48'h0000_0001_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Pattern Addition (All Ones)", test_num);
        rs1_data = 48'hAAAA_AAAA_AAAA;
        rs2_data = 48'h5555_5555_5555;
        cin = 0;
        #1;

        check_outputs(48'hFFFF_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overflow (Wrap Around)", test_num);
        rs1_data = 48'hFFFF_FFFF_FFFF;
        rs2_data = 48'h0000_0000_0000;
        cin = 1;
        #1;

        check_outputs(48'h0000_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Max Value + 1", test_num);
        rs1_data = 48'hFFFF_FFFF_FFFF;
        rs2_data = 48'h0000_0000_0001;
        cin = 0;
        #1;

        check_outputs(48'h0000_0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Complex Addition with cin", test_num);
        rs1_data = 48'h7FFF_0000_FFFF;
        rs2_data = 48'h0000_FFFF_0000;
        cin = 1;
        #1;

        check_outputs(48'h8000_0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd48 Testbench");
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
        input [47:0] expected_adder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h",
                         adder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h",
                         expected_adder_out);
                $display("  Got:      adder_out=%h",
                         adder_out);
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
