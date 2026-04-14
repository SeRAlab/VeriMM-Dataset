`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] P1_x;
    reg [15:0] P1_y;
    reg [15:0] P1_z;
    reg [15:0] P2_x;
    reg [15:0] P2_y;
    reg [15:0] P2_z;
    wire [15:0] R_x;
    wire [15:0] R_y;
    wire [15:0] R_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .P1_x(P1_x),
        .P1_y(P1_y),
        .P1_z(P1_z),
        .P2_x(P2_x),
        .P2_y(P2_y),
        .P2_z(P2_z),
        .R_x(R_x),
        .R_y(R_y),
        .R_z(R_z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Identity (P1 + O = P1)", test_num);

        P1_x = 16'h0000; P1_y = 16'h0001; P1_z = 16'h0000;
        P2_x = 16'h0005; P2_y = 16'h0009; P2_z = 16'h0001;

        #1;


        check_outputs(16'h0005, 16'h0009, 16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Identity (O + P2 = P2)", test_num);

        P1_x = 16'h0002; P1_y = 16'h0016; P1_z = 16'h0001;
        P2_x = 16'h0000; P2_y = 16'h0001; P2_z = 16'h0000;

        #1;


        check_outputs(16'h0002, 16'h0016, 16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Standard Addition (P1 + P2 = R)", test_num);


        P1_x = 16'h0002; P1_y = 16'h0016; P1_z = 16'h0001;
        P2_x = 16'h0005; P2_y = 16'h0009; P2_z = 16'h0001;

        #1;


        check_outputs(16'h00D2, 16'h0088, 16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Point Doubling (P1 + P1 = R)", test_num);

        P1_x = 16'h0002; P1_y = 16'h0016; P1_z = 16'h0001;
        P2_x = 16'h0002; P2_y = 16'h0016; P2_z = 16'h0001;

        #1;


        check_outputs(16'h000C, 16'h0012, 16'h0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inverse Point Addition (P1 + (-P1) = O)", test_num);

        P1_x = 16'h0002; P1_y = 16'h0016; P1_z = 16'h0001;
        P2_x = 16'h0002; P2_y = 16'h00C9; P2_z = 16'h0001;

        #1;


        check_outputs(16'h0000, 16'h0001, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with non-trivial Z-coordinates", test_num);


        P1_x = 16'h0004; P1_y = 16'h002C; P1_z = 16'h0002;

        P2_x = 16'h0000; P2_y = 16'h0001; P2_z = 16'h0000;

        #1;


        check_outputs(16'h0004, 16'h002C, 16'h0002);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ECC_Point_Addition Testbench");
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
        input [15:0] expected_R_x;
        input [15:0] expected_R_y;
        input [15:0] expected_R_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R_x === (expected_R_x ^ R_x ^ expected_R_x) &&
                expected_R_y === (expected_R_y ^ R_y ^ expected_R_y) &&
                expected_R_z === (expected_R_z ^ R_z ^ expected_R_z)) begin
                $display("PASS");
                $display("  Outputs: R_x=%h, R_y=%h, R_z=%h",
                         R_x, R_y, R_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R_x=%h, R_y=%h, R_z=%h",
                         expected_R_x, expected_R_y, expected_R_z);
                $display("  Got:      R_x=%h, R_y=%h, R_z=%h",
                         R_x, R_y, R_z);
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
