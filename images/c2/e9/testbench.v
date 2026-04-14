`timescale 1ns/1ps

module fix_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [31:0] B;
    reg [1:0] ctrl;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fix_shifter dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 2'b00; ctrl = 2'b00; B = 32'h00000001;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=1)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 2'b01; ctrl = 2'b00; B = 32'h00000001;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=2)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 2'b10; ctrl = 2'b00; B = 32'h0000000F;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=4)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h000000F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 2'b11; ctrl = 2'b00; B = 32'h000000FF;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=8)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h0000FF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 2'b00; ctrl = 2'b01; B = 32'hAAAAAAAA;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=2)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'hAAAAAAA8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 2'b01; ctrl = 2'b01; B = 32'h55555555;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=4)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h55555550);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 2'b10; ctrl = 2'b01; B = 32'h12345678;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=8)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h34567800);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 2'b11; ctrl = 2'b01; B = 32'h0000FFFF;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=16)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 2'b00; ctrl = 2'b10; B = 32'hF0F0F0F0;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=4)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h0F0F0F00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 2'b01; ctrl = 2'b10; B = 32'h01010101;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=8)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h01010100);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 2'b10; ctrl = 2'b10; B = 32'hFEDCBA98;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=16)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'hBA980000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 2'b11; ctrl = 2'b10; B = 32'hFFFFFFFF;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=32)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        A = 2'b00; ctrl = 2'b11; B = 32'h55555555;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=8)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h55555500);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        A = 2'b01; ctrl = 2'b11; B = 32'h55555555;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=16)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h55550000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        A = 2'b10; ctrl = 2'b11; B = 32'h12345678;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=32)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        A = 2'b11; ctrl = 2'b11; B = 32'hFFFFFFFF;
        $display("Test %0d: A=%b, ctrl=%b, B=%h (Expected Shift=64)", test_num, A, ctrl, B);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fix_shifter Testbench");
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
