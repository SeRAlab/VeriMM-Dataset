`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] I0;
    reg [31:0] I1;
    reg [31:0] I2;
    reg [31:0] I3;
    reg [31:0] I4;
    reg [31:0] I5;
    reg [31:0] I6;
    reg [31:0] I7;
    reg [2:0] s;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .I6(I6),
        .I7(I7),
        .s(s),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select I0", test_num);
            s = 3'b000;
            I0 = 32'hAAAA_AAAA; I1 = 32'h0; I2 = 32'h0; I3 = 32'h0;
            I4 = 32'h0; I5 = 32'h0; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select I1", test_num);
            s = 3'b001;
            I0 = 32'h0; I1 = 32'h5555_5555; I2 = 32'h0; I3 = 32'h0;
            I4 = 32'h0; I5 = 32'h0; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select I2", test_num);
            s = 3'b010;
            I0 = 32'h0; I1 = 32'h0; I2 = 32'h1234_5678; I3 = 32'h0;
            I4 = 32'h0; I5 = 32'h0; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select I3", test_num);
            s = 3'b011;
            I0 = 32'h0; I1 = 32'h0; I2 = 32'h0; I3 = 32'hDEAD_BEEF;
            I4 = 32'h0; I5 = 32'h0; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select I4", test_num);
            s = 3'b100;
            I0 = 32'h0; I1 = 32'h0; I2 = 32'h0; I3 = 32'h0;
            I4 = 32'hC0DE_D00D; I5 = 32'h0; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'hC0DE_D00D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select I5", test_num);
            s = 3'b101;
            I0 = 32'h0; I1 = 32'h0; I2 = 32'h0; I3 = 32'h0;
            I4 = 32'h0; I5 = 32'hBAAD_F00D; I6 = 32'h0; I7 = 32'h0;
            #1;

            check_outputs(32'hBAAD_F00D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select I6", test_num);
            s = 3'b110;
            I0 = 32'h0; I1 = 32'h0; I2 = 32'h0; I3 = 32'h0;
            I4 = 32'h0; I5 = 32'h0; I6 = 32'hFFFF_FFFF; I7 = 32'h0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select I7", test_num);
            s = 3'b111;
            I0 = 32'h1; I1 = 32'h2; I2 = 32'h3; I3 = 32'h4;
            I4 = 32'h5; I5 = 32'h6; I6 = 32'h7; I7 = 32'h8;
            #1;

            check_outputs(32'h0000_0008);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Dynamic Data Change on selected line (I0)", test_num);
            s = 3'b000;
            I0 = 32'h1111_1111;
            #5;
            I0 = 32'h2222_2222;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Verify all inputs with non-zero data", test_num);
            I0=32'h0; I1=32'h1; I2=32'h2; I3=32'h3; I4=32'h4; I5=32'h5; I6=32'h6; I7=32'h7;
            s = 3'b011;
            #1;

            check_outputs(32'h0000_0003);
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
