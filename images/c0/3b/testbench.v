`timescale 1ns/1ps

module zzadd64_lv_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [63:0] rs1_data;
    reg [63:0] rs2_data;
    wire [63:0] adder_out;
    wire cout32;
    wire cout64;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd64_lv dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .adder_out(adder_out),
        .cout32(cout32),
        .cout64(cout64)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            rs1_data = 64'h0;
            rs2_data = 64'h0;
            cin = 0;
            #1;

            check_outputs(64'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple Addition (No Carries)", test_num);
            rs1_data = 64'h1234_5678_1234_5678;
            rs2_data = 64'h1111_1111_1111_1111;
            cin = 0;
            #1;

            check_outputs(64'h2345_6789_2345_6789, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Carry-in check", test_num);
            rs1_data = 64'h0;
            rs2_data = 64'h0;
            cin = 1;
            #1;

            check_outputs(64'h1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Trigger cout32", test_num);
            rs1_data = 64'h0000_0000_FFFF_FFFF;
            rs2_data = 64'h0000_0000_0000_0001;
            cin = 0;

            #1;


            check_outputs(64'h0000_0001_0000_0000, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Trigger cout64", test_num);
            rs1_data = 64'hFFFF_FFFF_0000_0000;
            rs2_data = 64'h0000_0001_0000_0000;
            cin = 0;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Full propagation cin -> cout32 -> cout64", test_num);
            rs1_data = 64'hFFFF_FFFF_FFFF_FFFF;
            rs2_data = 64'h0000_0000_0000_0000;
            cin = 1;


            #1;



            check_outputs(64'h0000_0000_0000_0000, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Maximum Values with cin=1", test_num);
            rs1_data = 64'hFFFF_FFFF_FFFF_FFFF;
            rs2_data = 64'hFFFF_FFFF_FFFF_FFFF;
            cin = 1;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bit Pattern Addition", test_num);
            rs1_data = 64'hAAAA_AAAA_AAAA_AAAA;
            rs2_data = 64'h5555_5555_5555_5555;
            cin = 0;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Boundary - 1", test_num);
            rs1_data = 64'h0000_0000_FFFF_FFFE;
            rs2_data = 64'h0000_0000_0000_0001;
            cin = 0;
            #1;

            check_outputs(64'h0000_0000_FFFF_FFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: High boundary carry only", test_num);
            rs1_data = 64'h8000_0000_0000_0000;
            rs2_data = 64'h8000_0000_0000_0000;
            cin = 0;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd64_lv Testbench");
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
        input [63:0] expected_adder_out;
        input expected_cout32;
        input expected_cout64;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out) &&
                expected_cout32 === (expected_cout32 ^ cout32 ^ expected_cout32) &&
                expected_cout64 === (expected_cout64 ^ cout64 ^ expected_cout64)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h, cout32=%b, cout64=%b",
                         adder_out, cout32, cout64);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h, cout32=%b, cout64=%b",
                         expected_adder_out, expected_cout32, expected_cout64);
                $display("  Got:      adder_out=%h, cout32=%b, cout64=%b",
                         adder_out, cout32, cout64);
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
