`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] In1;
    reg [3:0] Sel;
    wire [7:0] Out0;
    wire [7:0] Out1;
    wire [7:0] Out10;
    wire [7:0] Out11;
    wire [7:0] Out12;
    wire [7:0] Out13;
    wire [7:0] Out2;
    wire [7:0] Out3;
    wire [7:0] Out4;
    wire [7:0] Out5;
    wire [7:0] Out6;
    wire [7:0] Out7;
    wire [7:0] Out8;
    wire [7:0] Out9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1(In1),
        .Sel(Sel),
        .Out0(Out0),
        .Out1(Out1),
        .Out10(Out10),
        .Out11(Out11),
        .Out12(Out12),
        .Out13(Out13),
        .Out2(Out2),
        .Out3(Out3),
        .Out4(Out4),
        .Out5(Out5),
        .Out6(Out6),
        .Out7(Out7),
        .Out8(Out8),
        .Out9(Out9)
    );
    task reset_outputs;

        integer i;
        begin
            In1 = 8'h00;
            for (i = 0; i < 14; i = i + 1) begin
                Sel = i[3:0];
                #10;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Set Out0 to A5h and verify others are 0", test_num);
            reset_outputs();

            In1 = 8'hA5;
            Sel = 4'd0;
            #10;



            #1;




            check_outputs(8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Set Out0 then Out1, verify Out0 is retained", test_num);
            reset_outputs();


            In1 = 8'h11;
            Sel = 4'd0;
            #10;


            In1 = 8'h22;
            Sel = 4'd1;
            #10;


            #1;



            check_outputs(8'h11, 8'h22, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Set boundary Out13", test_num);
            reset_outputs();

            In1 = 8'hFF;
            Sel = 4'd13;
            #10;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Set Out2, Out7, Out10", test_num);
            reset_outputs();

            In1 = 8'h22; Sel = 4'd2; #10;
            In1 = 8'h77; Sel = 4'd7; #10;
            In1 = 8'hAA; Sel = 4'd10; #10;


            #1;



            check_outputs(8'h00, 8'h00, 8'hAA, 8'h00, 8'h00, 8'h00, 8'h22, 8'h00, 8'h00, 8'h00, 8'h00, 8'h77, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Verify retention when Sel is out of range (14-15)", test_num);
            reset_outputs();


            In1 = 8'hCC;
            Sel = 4'd5;
            #10;


            Sel = 4'd14;
            In1 = 8'hEE;
            #10;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hCC, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple updates to Out9", test_num);
            reset_outputs();

            In1 = 8'h10; Sel = 4'd9; #10;
            In1 = 8'h20; Sel = 4'd9; #10;
            In1 = 8'h30; Sel = 4'd9; #10;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h30);
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
        input [7:0] expected_Out0;
        input [7:0] expected_Out1;
        input [7:0] expected_Out10;
        input [7:0] expected_Out11;
        input [7:0] expected_Out12;
        input [7:0] expected_Out13;
        input [7:0] expected_Out2;
        input [7:0] expected_Out3;
        input [7:0] expected_Out4;
        input [7:0] expected_Out5;
        input [7:0] expected_Out6;
        input [7:0] expected_Out7;
        input [7:0] expected_Out8;
        input [7:0] expected_Out9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out0 === (expected_Out0 ^ Out0 ^ expected_Out0) &&
                expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1) &&
                expected_Out10 === (expected_Out10 ^ Out10 ^ expected_Out10) &&
                expected_Out11 === (expected_Out11 ^ Out11 ^ expected_Out11) &&
                expected_Out12 === (expected_Out12 ^ Out12 ^ expected_Out12) &&
                expected_Out13 === (expected_Out13 ^ Out13 ^ expected_Out13) &&
                expected_Out2 === (expected_Out2 ^ Out2 ^ expected_Out2) &&
                expected_Out3 === (expected_Out3 ^ Out3 ^ expected_Out3) &&
                expected_Out4 === (expected_Out4 ^ Out4 ^ expected_Out4) &&
                expected_Out5 === (expected_Out5 ^ Out5 ^ expected_Out5) &&
                expected_Out6 === (expected_Out6 ^ Out6 ^ expected_Out6) &&
                expected_Out7 === (expected_Out7 ^ Out7 ^ expected_Out7) &&
                expected_Out8 === (expected_Out8 ^ Out8 ^ expected_Out8) &&
                expected_Out9 === (expected_Out9 ^ Out9 ^ expected_Out9)) begin
                $display("PASS");
                $display("  Outputs: Out0=%h, Out1=%h, Out10=%h, Out11=%h, Out12=%h, Out13=%h, Out2=%h, Out3=%h, Out4=%h, Out5=%h, Out6=%h, Out7=%h, Out8=%h, Out9=%h",
                         Out0, Out1, Out10, Out11, Out12, Out13, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out0=%h, Out1=%h, Out10=%h, Out11=%h, Out12=%h, Out13=%h, Out2=%h, Out3=%h, Out4=%h, Out5=%h, Out6=%h, Out7=%h, Out8=%h, Out9=%h",
                         expected_Out0, expected_Out1, expected_Out10, expected_Out11, expected_Out12, expected_Out13, expected_Out2, expected_Out3, expected_Out4, expected_Out5, expected_Out6, expected_Out7, expected_Out8, expected_Out9);
                $display("  Got:      Out0=%h, Out1=%h, Out10=%h, Out11=%h, Out12=%h, Out13=%h, Out2=%h, Out3=%h, Out4=%h, Out5=%h, Out6=%h, Out7=%h, Out8=%h, Out9=%h",
                         Out0, Out1, Out10, Out11, Out12, Out13, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9);
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
