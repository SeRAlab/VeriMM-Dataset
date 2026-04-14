`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    wire [15:0] l11;
    wire [15:0] l12;
    wire [15:0] l21;
    wire [15:0] l22;
    wire [15:0] u11;
    wire [15:0] u12;
    wire [15:0] u21;
    wire [15:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lu_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .l11(l11),
        .l12(l12),
        .l21(l21),
        .l22(l22),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );
    task testcase001;

    begin
        test_num = 1;

        a = 16'd1; b = 16'd0; c = 16'd0; d = 16'd1;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001, 16'h0001, 16'h0000, 16'h0000, 16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        a = 16'd2; b = 16'd4; c = 16'd4; d = 16'd10;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001, 16'h0002, 16'h0004, 16'h0000, 16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        a = 16'd4; b = 16'd8; c = 16'd12; d = 16'd30;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0004, 16'h0008, 16'h0000, 16'h0006);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        a = 16'd5; b = 16'd10; c = 16'd20; d = 16'd50;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0004, 16'h0001, 16'h0005, 16'h000a, 16'h0000, 16'h000a);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        a = 16'd2; b = 16'd1; c = 16'd6; d = 16'd5;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0002, 16'h0001, 16'h0000, 16'h0002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        a = 16'd10; b = 16'd20; c = 16'd30; d = 16'd100;


        #1;



        check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h000a, 16'h0014, 16'h0000, 16'h0028);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lu_decomposition Testbench");
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
        input [15:0] expected_l11;
        input [15:0] expected_l12;
        input [15:0] expected_l21;
        input [15:0] expected_l22;
        input [15:0] expected_u11;
        input [15:0] expected_u12;
        input [15:0] expected_u21;
        input [15:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u21 === (expected_u21 ^ u21 ^ expected_u21) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         expected_l11, expected_l12, expected_l21, expected_l22, expected_u11, expected_u12, expected_u21, expected_u22);
                $display("  Got:      l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
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
