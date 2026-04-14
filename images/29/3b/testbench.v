`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] opcode;
    wire Z;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Z(Z),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        opcode = 4'b0000;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        opcode = 4'b0001;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h1234_5678;
        B = 32'h1234_5678;
        opcode = 4'b0010;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'd100;
        B = 32'd250;
        opcode = 4'b0011;
        #1;

        check_outputs(1'b0, 32'd350);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h0000_00FF;
        B = 32'h0000_00FF;
        opcode = 4'b0100;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        opcode = 4'b0101;
        #1;

        check_outputs(1'b0, 32'h0000_0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'h0000_0001;
        B = 32'hFFFF_FFFF;
        opcode = 4'b0101;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'h0000_FFFF;
        B = 32'hFFFF_0000;
        opcode = 4'b0110;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        opcode = 4'b0111;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        opcode = 4'b1000;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 32'h8000_0000;
        B = 32'd4;
        opcode = 4'b1001;
        #1;

        check_outputs(1'b0, 32'hF800_0000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 32'h0000_0001;
        B = 32'd8;
        opcode = 4'b1010;
        #1;

        check_outputs(1'b0, 32'h0000_0100);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        A = 32'h8000_0000;
        B = 32'd1;
        opcode = 4'b1011;
        #1;

        check_outputs(1'b0, 32'h4000_0000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        A = 32'hF0F0_F0F0;
        B = 32'hFFFF_FFFF;
        opcode = 4'b1100;
        #1;

        check_outputs(1'b0, 32'h0F0F_0F0F);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        A = 32'hDEAD_BEEF;
        B = 32'h0000_0000;
        opcode = 4'b1101;
        #1;

        check_outputs(1'b0, 32'hDEAD_BEEF);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        A = 32'h0000_0000;
        B = 32'hCAFE_BABE;
        opcode = 4'b1110;
        #1;

        check_outputs(1'b0, 32'hCAFE_BABE);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        opcode = 4'b1111;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input expected_Z;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: Z=%b, result=%h",
                         Z, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b, result=%h",
                         expected_Z, expected_result);
                $display("  Got:      Z=%b, result=%h",
                         Z, result);
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
